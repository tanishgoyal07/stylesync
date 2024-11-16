import pandas as pd
import numpy as np
from scipy.stats import pearsonr
from surprise import Dataset, Reader, SVD
from surprise.model_selection import train_test_split
from surprise import accuracy

# Load the user and designer data
user_data = pd.read_csv('input-files/users.csv')
designer_data = pd.read_csv('input-files/designers.csv')

# Preprocessing Designer Data
def preprocess_designers(designer_data):
    designer_data['expertCategory'] = designer_data['expertCategory'].apply(lambda x: x.split(','))
    designer_data['expertSubCategory'] = designer_data['expertSubCategory'].apply(lambda x: x.split(','))
    designer_data['experiencedIn'] = designer_data['experiencedIn'].apply(lambda x: x.split(','))
    designer_data['ageGroup'] = designer_data['ageGroup'].apply(lambda x: x.split(','))
    return designer_data

designer_data = preprocess_designers(designer_data)

# Preprocessing User Data
def categorize_user_by_age_gender(row):
    if row['age'] <= 16:
        return 'Girls' if row['gender'] == 'Women' else 'Boys'
    else:
        return 'Women' if row['gender'] == 'Women' else 'Men'

user_data['ageGroup'] = user_data.apply(categorize_user_by_age_gender, axis=1)

# Content-Based Filtering with Pearson Correlation Similarity
def calculate_content_score(user, designer):
    score = 0

    user_attributes = {
        'usage': [user['usage']],
        'category': [user['category']],
        'articleType': [user['articleType']],
        'ageGroup': [user['ageGroup']],
    }

    usage_match = len(set(user_attributes['usage']).intersection(set(designer['expertCategory']))) > 0
    score += 5 if usage_match else 0

    category_match = len(set(user_attributes['category']).intersection(set(designer['expertSubCategory']))) > 0
    score += 4 if category_match else 0

    article_type_match = len(set(user_attributes['articleType']).intersection(set(designer['experiencedIn']))) > 0
    score += 3 if article_type_match else 0

    age_group_match = len(set(user_attributes['ageGroup']).intersection(set(designer['ageGroup']))) > 0
    score += 2 if age_group_match else 0

    user_amount = user['amount']
    designer_pricing = designer['averagePricing']
    price_diff = abs(user_amount - designer_pricing)
    max_price_diff = user_data['amount'].max() - user_data['amount'].min()
    price_score = (max_price_diff - price_diff) / max_price_diff
    score += price_score

    return score

# Collaborative Filtering Setup
def prepare_collaborative_filtering(user_data, designer_data):
    interaction_data = []
    for user_id, user in user_data.iterrows():
        for designer_id, designer in designer_data.iterrows():
            score = calculate_content_score(user, designer)
            interaction_data.append([user_id, designer_id, score])

    interaction_df = pd.DataFrame(interaction_data, columns=['user_id', 'designer_id', 'interaction'])
    reader = Reader(rating_scale=(0, 15))
    data = Dataset.load_from_df(interaction_df[['user_id', 'designer_id', 'interaction']], reader)

    return data, interaction_df

data, interaction_df = prepare_collaborative_filtering(user_data, designer_data)
trainset, testset = train_test_split(data, test_size=0.2)

# Train collaborative filtering model
algo = SVD()
algo.fit(trainset)

# Predict ratings and calculate RMSE
predictions = algo.test(testset)
rmse = accuracy.rmse(predictions)

# Preprocessing function for single user
def preprocess_new_user(user):
    user['ageGroup'] = categorize_user_by_age_gender(user)
    return user

# Recommendation for a Single User
def recommend_designers_for_new_user(user_preferences, designer_data, algo):
    # Preprocess the user input
    user = preprocess_new_user(user_preferences)
    
    designer_scores = []

    for designer_id, designer in designer_data.iterrows():
        # Content-based score
        content_score = calculate_content_score(user, designer)

        # Collaborative filtering score
        cf_score = algo.predict(uid=len(user_data), iid=designer_id).est if len(user_data) > 0 else 0

        # Hybrid score
        hybrid_score = 0.6 * content_score + 0.4 * cf_score
        designer_scores.append((designer_id, hybrid_score))

    # Sort designers by hybrid score
    designer_scores.sort(key=lambda x: x[1], reverse=True)
    top_three_designers = [designer_id for designer_id, _ in designer_scores[:3]]

    # Return the details of the top three designers
    return designer_data.iloc[top_three_designers]