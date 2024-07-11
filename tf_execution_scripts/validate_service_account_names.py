import pandas as pd


input_sa_csv_file = "sample_service_account_input.csv"


data = pd.read_csv(input_sa_csv_file, index_col=[0])


### Service account name has a constraint of maximum of 64 characters. This needs to be validated.

data["sa_length"] = data["service_account_name"].apply(len)

print("Following are the service accounts with character length more than 64:\n")

print(data.loc[data["sa_length"] > 64, ["service_account_name", "sa_length"]].set_index("service_account_name")["sa_length"].to_dict())


### Check for duplicate service names for different applications. 

app_count_per_sa = data.groupby("service_account_name").apply(lambda x: x.drop_duplicates("application_name")["application_name"].shape[0])

print("\nFollowing are the service accounts which have been used for more than 1 application:\n")

print(app_count_per_sa[app_count_per_sa > 1].to_dict())

print("\nPlease resolve the above concerns if any before proceeding")