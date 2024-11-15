import pandas as pd
import numpy as np
from sklearn.preprocessing import OneHotEncoder, MinMaxScaler
from sklearn.metrics.pairwise import cosine_similarity
from surprise import Dataset, Reader, SVD
from surprise.model_selection import train_test_split
from surprise import accuracy

# Load data
user_data = pd.read_csv('input-files/users.csv')
designer_data = pd.read_csv('input-files/designers.csv')

# Function to map users to categories based on age and gender
def categorize_user_by_age_gender(row):
    if row['age'] <= 16:
        return 'Girls' if row['gender'] == 'Women' else 'Boys'
    else:
        return 'Women' if row['gender'] == 'Women' else 'Men'

# Apply the function to create a new column 'ageGroup' in user_data
user_data['ageGroup'] = user_data.apply(categorize_user_by_age_gender, axis=1)

# Preprocessing & Encoding
# Combine unique categories for consistent encoding space
combined_categories = pd.concat([
    user_data[['usage', 'category', 'articleType', 'ageGroup']],
    designer_data[['expertCategory', 'expertSubCategory', 'experiencedIn', 'ageGroup']].rename(
        columns={'expertCategory': 'usage', 'expertSubCategory': 'category', 'experiencedIn': 'articleType', 'ageGroup': 'ageGroup'}
    )
], ignore_index=True).drop_duplicates()

# Fit the encoder on the combined unique categories with handle_unknown='ignore'
encoder = OneHotEncoder(handle_unknown='ignore')
encoder.fit(combined_categories)

# Transform user and designer data using the fitted encoder
user_items_encoded = encoder.transform(user_data[['usage', 'category', 'articleType', 'ageGroup']]).toarray()
designer_expertise_encoded = encoder.transform(
    designer_data[['expertCategory', 'expertSubCategory', 'experiencedIn', 'ageGroup']].rename(
        columns={'expertCategory': 'usage', 'expertSubCategory': 'category', 'experiencedIn': 'articleType', 'ageGroup': 'ageGroup'}
    )
).toarray()

# Calculate Cosine Similarity for items/categories
item_similarity = cosine_similarity(user_items_encoded, designer_expertise_encoded)

# Find the closest matching 'averagePricing' for the user's 'amount'
def match_closest_price(user_amount, designer_prices):
    designer_prices = np.squeeze(designer_prices)
    price_diff = np.abs(designer_prices - user_amount)
    return price_diff

# Normalize "Total Customers Served"
scaler = MinMaxScaler()
total_customers_normalized = scaler.fit_transform(designer_data[['totalCustomersServed']].values)

# Include age group match with increased weight
def calculate_similarity_with_age(user_idx, designer_idx, is_new_user=False, new_user_age_group=None):
    item_sim_score = item_similarity[user_idx, designer_idx] if user_idx is not None else 0
    
    if is_new_user:
        age_similarity = 0.7 if new_user_age_group == designer_data.iloc[designer_idx]['ageGroup'] else 0
    else:
        age_similarity = 0.7 if user_data.iloc[user_idx]['ageGroup'] == designer_data.iloc[designer_idx]['ageGroup'] else 0
    
    total_customers_weight = total_customers_normalized[designer_idx][0]  # Weight based on total customers served
    
    return item_sim_score + age_similarity + total_customers_weight

# Map availability to integers (Yes -> 1, No -> 0)
availability = designer_data['availability'].map({'Yes': 1, 'No': 0}).values.astype(int)

# Create a DataFrame for user-designer interactions
user_designer_interactions = []
for user_idx, user in user_data.iterrows():
    for designer_idx, designer in designer_data.iterrows():
        interaction_score = item_similarity[user_idx, designer_idx]
        user_designer_interactions.append([user_idx, designer_idx, interaction_score])

interactions_df = pd.DataFrame(user_designer_interactions, columns=['user_id', 'designer_id', 'interaction'])

# Use Surprise to build a collaborative filtering model
reader = Reader(rating_scale=(0, 1))
data = Dataset.load_from_df(interactions_df, reader)

# Split the dataset into training and test sets
trainset, testset = train_test_split(data, test_size=0.2)

# Use SVD algorithm for collborative filtering
algo = SVD()
algo.fit(trainset)

# Predict ratings for the testset
predictions = algo.test(testset)

# Correct Accuracy Calculation
def correct_accuracy_calculation(rmse):
    accuracy_percentage = max(0, (1 - rmse / 5) * 100)
    return accuracy_percentage

# Calculate RMSE and accuracy percentage
rmse = accuracy.rmse(predictions)
accuracy_percentage = correct_accuracy_calculation(rmse)

# Recommend designers for a new user
def recommend_designers_for_new_user(new_user_input):
    
    print("\nUser Input Data:")
    print(new_user_input)
    
    new_user_input['ageGroup'] = categorize_user_by_age_gender(new_user_input)
    
    new_user_encoded = encoder.transform(
        pd.DataFrame([new_user_input])[['usage', 'category', 'articleType', 'ageGroup']]
    ).toarray()
    
    new_user_similarity = cosine_similarity(new_user_encoded, designer_expertise_encoded)
    
    designer_ratings = []
    price_diff = match_closest_price(new_user_input['amount'], designer_data['averagePricing'].values)
    
    for designer_idx, designer in designer_data.iterrows():
        if designer['availability'] == 'Yes':
            age_clothing_similarity = calculate_similarity_with_age(
                user_idx=None, designer_idx=designer_idx, is_new_user=True, new_user_age_group=new_user_input['ageGroup']
            )
            predicted_rating = algo.predict(uid=len(user_data), iid=designer_idx).est
            
            total_score = predicted_rating + new_user_similarity[0, designer_idx] + age_clothing_similarity - price_diff[designer_idx]
            designer_ratings.append((designer_idx, total_score))
    
    designer_ratings.sort(key=lambda x: x[1], reverse=True)
    
    top_recommendations = designer_ratings[:3]
    
    return designer_data.iloc[[idx for idx, _ in top_recommendations]]


# Output accuracy percentage once
print(f'Accuracy Percentage: {accuracy_percentage}%')
