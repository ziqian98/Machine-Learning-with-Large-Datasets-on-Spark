class SentiDict:
    def __init__(self):
        self.dict = dict()
        self.count = list()
        self.pos_score = list()
        self.neu_score = list()
        self.neg_score = list()

    def load_dictionary(self, filename):
        index = 0
        with open(filename, "r") as f:
            for line in f.readlines():
                if line.startswith("#"):
                    continue
                cols = line.split("\t")
                try:
                    for entry in cols[4].split():
                        word = entry.split("#")[0]
                        pos_score = float(cols[2])
                        neg_score = float(cols[3])
                        neu_score = 1 - pos_score - neg_score
                        if word not in self.dict.keys():
                            self.dict[word] = index
                            self.count.append(1)
                            self.pos_score.append(pos_score)
                            self.neg_score.append(neg_score)
                            self.neu_score.append(neu_score)
                            index += 1
                        else:
                            self.count[self.dict[word]] += 1
                            self.pos_score[self.dict[word]] += pos_score
                            self.neg_score[self.dict[word]] += neg_score
                            self.neu_score[self.dict[word]] += neu_score
                except ValueError:
                    continue

        for i in self.dict.values():
            self.pos_score[i] /= self.count[i]
            self.neg_score[i] /= self.count[i]
            self.neu_score[i] /= self.count[i]

    def encode(self, sentence):
        encoded = [self.dict[word] for word in sentence.split() if word in self.dict]
        return encoded, len(encoded)

    def get_score(self, sentence):
        pos_score = 0
        neu_score = 0
        neg_score = 0
        encoded, encoded_len = self.encode(sentence)
        for index in encoded:
            pos_score += self.pos_score[index]
            neu_score += self.neu_score[index]
            neg_score += self.neg_score[index]
        return pos_score / encoded_len, neu_score / encoded_len, neg_score / encoded_len

    def __getitem__(self, item):
        return self.dict[item]

    def __contains__(self, item):
        return item in self.dict.keys()


if __name__ == "__main__":
    SD = SentiDict()
    SD.load_dictionary("../../data/SentiWordNet_3.0.0.txt")

    sample = "able dorsal ."
    print(SD.get_score(sample))
