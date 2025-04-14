# The Importance of Data Splitting

# Train, Test, and Validation Splits

The first step in our classification task is to randomly split our pets into three independent sets:

**Training Set**: The dataset that we feed our model to learn potential underlying patterns and relationships.

**Validation Set**: The dataset that we use to understand our model's performance across different model types and hyperparameter choices.

**Test Set**: The dataset that we use to approximate our model's unbiased accuracy in the wild.

# The Training Set
The training set is the dataset that we employ to train our model.
It is this dataset that our model uses to learn any underlying patterns or relationships that will enable making predictions later on.

The training set should be as representative as possible of the population that we are trying to model.
Additionally, we need to be careful and ensure that it is as unbiased as possible, as any bias at this stage may be propagated downstream during inference.

# Building Our Model
- Our goal (to determine whether a given pet is a cat or a dog) is a binary classification task, so we will use a simple but effective model appropriate for this task: logistic regression.

- Logistic regression will learn a decision boundary to best separate the cats from dogs in our training data, using the selected feature (None, Weight, Fluffiness, or both Weight and Fluffiness).

- Select the feature to visualize the corresponding logistic regression model's decision boundary. Drag each animal in the training set to a new position to see how the boundary updates!

# The Validation Set
- We can build four different logistic regression models (one for each feature possibility), how do we decide which model to select?

- We could compare the accuracy of each model on the training set, but if we use the same exact dataset for both training and tuning, the model will overfit and won't generalize well.

- This is where the validation set comes in — it acts as an independent, unbiased dataset for comparing the performance of different algorithms trained on our training set.

- Select a feature to view the model's performance on the validation set in the table below. Drag the pets across the line to see how the model performance updates!

# The Validation Set
- We can build four different logistic regression models (one for each feature possibility), how do we decide which model to select?

- We could compare the accuracy of each model on the training set, but if we use the same exact dataset for both training and tuning, the model will overfit and won't generalize well.

- This is where the validation set comes in — it acts as an independent, unbiased dataset for comparing the performance of different algorithms trained on our training set.

S- elect a feature to view the model's performance on the validation set in the table below. Drag the pets across the line to see how the model performance updates!

# The Testing Set
Once we have used the validation set to determine the algorithm and parameter choices that we would like to use in production, the test set is used to approximate the models's true performance in the wild. It is the final step in evaluating our model's performance on unseen data.

We should never, under any circumstance, look at the test set's performance before selecting a model.

Peeking at our test set performance ahead of time is a form of overfitting, and will likely lead to unreliable performance expectations in production. It should only be checked as the final form of evaluation, after the validation set has been used to identify the best model.
