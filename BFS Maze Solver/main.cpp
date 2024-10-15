#include <iostream>
#include <vector>
#include <queue>
#include <list>
#include <sstream>
//#inclurd <utitlity>

using namespace std;


class Pathway
{
public:
    Pathway(){};        //Just for the currPath variable

    Pathway(pair<int,int> startPosition)
    {
        vecBreadcrums.push_back(startPosition);

        currPosition = startPosition;
    }
    Pathway(Pathway& lastPath, pair<int, int> nextPosition)
    {
        vecBreadcrums = lastPath.GetPathway();
        vecBreadcrums.push_back(nextPosition);

        currPosition = nextPosition;
    }

    pair<int, int>& CurrPos()
    {
        return currPosition;
    }

    vector<pair<int,int>>& GetPathway()
    {
        return vecBreadcrums;
    }

private:
    pair<int, int> currPosition;
    vector<pair<int,int>> vecBreadcrums;
};

int RowSize, ColSize;

pair<int,int> posStart, posGoal;

vector<vector<char>> vecMaze;
vector<vector<char>> vecMaze_Out;

Pathway currPath;
queue<Pathway, list<Pathway>> queueOfPathways;

void ShortestDistance();

int main()
{
    string sLine;

   getline(cin, sLine, '\n');       //Takes in size of maze
   stringstream isIn(sLine);

    isIn >> RowSize >> ColSize;

    vecMaze = vector<vector<char>> (RowSize, vector<char> (ColSize));

    char cIn;

    for (int iRow = 0; iRow < RowSize; ++iRow)
    {
        getline(cin, sLine, '\n');      //Takes each line of maze to be processed

        for (int iCol = 0; iCol < ColSize; ++iCol)
        {
            cIn = sLine[iCol];

            if (cIn == 'S')
            {
                posStart = make_pair(iRow, iCol);
            }
            if (cIn == 'G')
            {
                posGoal = make_pair(iRow, iCol);
            }
            vecMaze[iRow][iCol] = cIn;
        }
    }

    vecMaze_Out = vecMaze;

    Pathway startPath = Pathway(posStart);
    queueOfPathways.push(startPath);

    ShortestDistance();     //Returns Shortest path of maze

    for (auto& row : vecMaze_Out)
    {
        for (auto& elem : row)
        {
            cout << elem ;
        }

        cout << endl;
    }

    return 0;
}

void ShortestDistance()
{
    if (queueOfPathways.empty())        //If there's no more paths to process
    {
        cout << "No Path" << endl;
        exit(0);
    }

    currPath = queueOfPathways.front();

    if (currPath.CurrPos() == posGoal)      //If we've found the shortest path
    {
        vector<pair<int,int>>& vecShortestPath = currPath.GetPathway();
        int iDistance = vecShortestPath.size() - 1;       //Will be iterating for [S+1, G-1]

        for (int posBreadcrumb = 1; posBreadcrumb < iDistance; ++ posBreadcrumb)
        {
            pair<int, int>& trailPos = vecShortestPath[posBreadcrumb];
            vecMaze_Out[trailPos.first][trailPos.second] = '*';
        }

        return;
    }

    //Check possible options to move from current path...

    Pathway nextPath;

    pair<int, int>& trailPos = currPath.CurrPos();
    int iCurrRow = trailPos.first, iCurrCol = trailPos.second;

    if ( (iCurrRow + 1 < RowSize) && (vecMaze[iCurrRow + 1][iCurrCol] != 'x') )      //Down
    {
        vecMaze[iCurrRow + 1][iCurrCol] = 'x';  //Mark that spot

        nextPath = Pathway(currPath, make_pair(iCurrRow + 1, iCurrCol));
        queueOfPathways.push(nextPath);
    }
    if ( (iCurrCol - 1 > 0) && (vecMaze[iCurrRow][iCurrCol-1] != 'x') )     //Left
    {
        vecMaze[iCurrRow][iCurrCol - 1] = 'x';  //Mark that spot

        nextPath = Pathway(currPath, make_pair(iCurrRow, iCurrCol - 1));
        queueOfPathways.push(nextPath);
    }
    if ( (iCurrRow - 1 > 0) && (vecMaze[iCurrRow -1][iCurrCol] != 'x'))     //Up
    {
        vecMaze[iCurrRow - 1][iCurrCol] = 'x';  //Mark that spot

        nextPath = Pathway(currPath, make_pair(iCurrRow - 1, iCurrCol));
        queueOfPathways.push(nextPath);
    }
    if ( (iCurrCol + 1 < ColSize) && (vecMaze[iCurrRow][iCurrCol + 1] != 'x'))  //Right
    {
        vecMaze[iCurrRow][iCurrCol + 1] = 'x';  //Mark that spot

        nextPath = Pathway(currPath, make_pair(iCurrRow, iCurrCol + 1));
        queueOfPathways.push(nextPath);
    }

    queueOfPathways.pop();      //Done with current position

    //Continue...

    ShortestDistance();
}
