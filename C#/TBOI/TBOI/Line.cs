using System;
using System.Windows.Media.TextFormatting;

namespace TBOI
{
    internal class Line
    {
        private int x;
        private int y;
        private int length;
        private bool dir;
        private ConsoleColor Fcolor;


        public Line(int x, int y, int length, bool dir, ConsoleColor Fcolor)
        {
            this.x = x;
            this.y = y;
            this.length = length;
            this.dir = dir;
            this.Fcolor = Fcolor;
        }
        #region setAndGet
        public void SetX(int x)
        {
            this.x = x;
        }
        public int GetX()
        {
            return x;
        }
        public void SetY(int y)
        {
            this.y = y;
        }
        public int GetY()
        {
            return y;
        }
        public void SetLength(int l)
        {
            this.length = l;
        }
        public int GetLength()
        {
            return this.length;
        }
        public void SetFcolor(ConsoleColor Fcolor)
        {
            this.Fcolor = Fcolor;
        }
        public ConsoleColor GetFcolor()
        {
            return this.Fcolor;
        }
        #endregion

        public void Draw()
        {

            this.DrawLine(this.Fcolor);
        }

        public void Undraw()
        {
            this.DrawLine(Console.BackgroundColor);
        }

        private void DrawLine(ConsoleColor color) // draws the line with the inputted color
        {
            Console.ForegroundColor = color;
            Console.SetCursorPosition(this.x, this.y);
            int x = this.x;
            int y = this.y;

            int length = this.length;
            if (length > 0)
            {
                for (int i = 0; i < length; i++)
                {
                    Console.SetCursorPosition(x, y);
                    if (dir)
                    {
                        Console.Write('║');
                        y++;
                    }
                    else
                    {
                        Console.Write('═');
                        x++;
                    }
                }
            }
        }
        
        public bool MoveCheck(MTP c, int xDif, int yDif)
        {
            bool xMatch = false;
            bool yMatch = false;
            int cX = c.GetX();
            int cY = c.GetY();
            if (dir)
            {
                if (cX == this.x + xDif)
                    xMatch = true;
                if (cY >= this.y + yDif && cY <= this.y + length - yDif)
                    yMatch = true;
            }
            else
            {
                if (cY == this.y + yDif)
                    yMatch = true;
                if (cX >= this.x + xDif && cX <= this.x + length - xDif)
                    xMatch = true;
            }

            return xMatch && yMatch;
        }

        public void AllCheck(MTP t)
        {
            if (MoveCheck(t, 1, 1) || MoveCheck(t, 1, -1) || MoveCheck(t, -1, 0) || MoveCheck(t, -1, 0))
            {
                t.SetAppear(false);
                t.SetCh(' ');
                t.SetX(80);
                t.SetY(25);
                t.SetDirection(2);
            }
            if (MoveCheck(t, 0, 1) || MoveCheck(t, 0, 0) || MoveCheck(t, 1, 1) || MoveCheck(t, -1, 1))
            {
                t.SetAppear(false);
                t.SetCh(' ');
                t.SetX(80);
                t.SetY(25);
                t.SetDirection(2);
            }
        }

        public void eMove(Character p, Character e, Line other)
        {
            Random rnd = new Random();

            int pX = p.GetP().GetX();
            int pY = p.GetP().GetY();
            int eX = e.GetP().GetX();
            int eY = e.GetP().GetY();
            int mDir = 0;

            if (eX <= pX)
            {
                if (eY >= pY)
                {
                    mDir = rnd.Next(4);

                }
                else
                {
                    mDir = rnd.Next(2, 5);
                }
            }
            else
            {
                if (eY <= pY)
                {
                    mDir = rnd.Next(4, 7);
                }
                else
                {
                    mDir = rnd.Next(6, 9) % 8;
                }
            }
            e.GetP().SetDirection(mDir);

            if (mDir == 0 && !MoveCheck(e.GetP(), 1, 1) && !other.MoveCheck(e.GetP(), 0, 1))
                e.GetP().MoveOneStep();
            else if (mDir == 1 && !MoveCheck(e.GetP(), 1, 1) && !other.MoveCheck(e.GetP(), 0, 1) && !MoveCheck(e.GetP(), -1, 0) && !other.MoveCheck(e.GetP(), -1, 1))
                e.GetP().MoveOneStep();
            else if (mDir == 2 && !MoveCheck(e.GetP(), -1, 0) && !other.MoveCheck(e.GetP(), -1, 1))
                e.GetP().MoveOneStep();
            else if (mDir == 3 && !MoveCheck(e.GetP(), -1, 0) && !other.MoveCheck(e.GetP(), -1, 1) && !MoveCheck(e.GetP(), 1, -1) && !other.MoveCheck(e.GetP(), 0, 0))
                e.GetP().MoveOneStep();
            else if (mDir == 4 && !MoveCheck(e.GetP(), 1, -1) && !other.MoveCheck(e.GetP(), 0, 0))
                e.GetP().MoveOneStep();
            else if (mDir == 5 && !MoveCheck(e.GetP(), 1, -1) && !other.MoveCheck(e.GetP(), 0, 0) && !MoveCheck(e.GetP(), -1, 0) && !other.MoveCheck(e.GetP(), 1, 1))
                e.GetP().MoveOneStep();
            else if (mDir == 6 && !MoveCheck(e.GetP(), -1, 0) && !other.MoveCheck(e.GetP(), 1, 1))
                e.GetP().MoveOneStep();
            else if (mDir == 7 && !MoveCheck(e.GetP(), -1, 0) && !other.MoveCheck(e.GetP(), 1, 1) && !MoveCheck(e.GetP(), 1, 1) && !other.MoveCheck(e.GetP(), 0, 1))
                e.GetP().MoveOneStep();

        }

        public override string ToString()
        {
            return "X:" + x + " Y:" + y + " Length:" + length + " Color:" + Fcolor;
        }
    }
}
