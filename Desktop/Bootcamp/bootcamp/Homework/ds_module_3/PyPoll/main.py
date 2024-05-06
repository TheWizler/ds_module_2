
















import csv

# Path 
file_path = 'PyPoll/Resources/election_data.csv'

# variables
total_votes = 0
candidates = {}

# Open and read CSV 
with open(file_path, mode='r') as file:
    reader = csv.reader(file)
    header = next(reader)  # Skip the header row

    # Process each row
    for row in reader:
        total_votes += 1
        candidate_name = row[2]  # candidate names 

        # If the candidate is already in the dictionary, increase incrementally
        if candidate_name in candidates:
            candidates[candidate_name] += 1
        else:
            # Otherwise, add the candidate to the dictionary with one vote
            candidates[candidate_name] = 1

# determine winner and output
winner = None
max_votes = 0
output = [
    "Election Results",
    "-------------------------",
    f"Total Votes: {total_votes}",
    "-------------------------"
]

for candidate, votes in candidates.items():
    vote_percentage = (votes / total_votes) * 100
    output.append(f"{candidate}: {vote_percentage:.3f}% ({votes})")
    if votes > max_votes:
        max_votes = votes
        winner = candidate

output += [
    "-------------------------",
    f"Winner: {winner}",
    "-------------------------"
]

# Print the output to the terminal
for line in output:
    print(line)

# Write the output to a text file
output_file_path = 'election_results.txt'
with open(output_file_path, 'w') as output_file:
    for line in output:
        output_file.write(line + '\n')
