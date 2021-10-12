using System.Collections;

/// <summary>
/// [TODO:description]
/// </summary>
public class TestCS
{
    /// <summary>
    /// [TODO:description]
    /// </summary>
    public const double PI = 3.14;


    /// <summary>
    /// [TODO:description]
    /// </summary>
    public int one = 1;

    /// <summary>
    /// [TODO:description]
    /// </summary>
    public int Prop { 
        get 
        { 
            return 1; 
        } 
        set 
        { 
        } 
    }

    /// <summary>
    /// [TODO:description]
    /// </summary>
    public event Del EventHappened;

    /// <summary>
    /// [TODO:description]
    /// </summary>
    /// <param name="number">[TODO:description]</param>
    public delegate void Del(int number);

    /// <summary>
    /// [TODO:description]
    /// </summary>
    /// <param name="first">[TODO:description]</param>
    /// <param name="second">[TODO:description]</param>
    /// <returns>[TODO:description]</returns>
    public static TestCS operator +(TestCS first, TestCS second) 
    { 
        return first; 
    }

    /// <summary>
    /// [TODO:description]
    /// </summary>
    public TestCS()
    {
    }

    /// <summary>
    /// [TODO:desription]
    /// </summary>
    /// <param name="arg1">[TODO:description]</param>
    public TestCS(string arg1)
    {
    }

    /// <summary>
    /// [TODO:desription]
    /// </summary>
    /// <param name="arg1">[TODO:description]</param>
    /// <param name="arg2">[TODO:description]</param>
    public TestCS(string arg1, List<string> arg2)
    {
    }

    /// <summary>
    /// [TODO:desription]
    /// </summary>
    /// <summary>
    /// [TODO:description]
    /// </summary>
    %(hasReturn|/// <retrurns>[TODO:description]</returns>
    public void ActualMethod1()
    {
    }

    /// <summary>
    /// [TODO:desription]
    /// </summary>
    /// <returns>[TODO:description]</returns>
    public void ActualMethodWitReturn()
    {
    }

    /// <summary>
    /// [TODO:desription]
    /// </summary>
    /// <param name="arg1">[TODO:description]</param>
    /// <param name="arg2">[TODO:description]</param>
    public void ActualMethodWitArgs(?List<string> arg1, int arg2)
    {
    }

    /// <summary>
    /// [TODO:desription]
    /// </summary>
    /// <param name="arg1">[TODO:description]</param>
    /// <param name="arg2">[TODO:description]</param>
    /// <returns>[TODO:description]</returns>
    public string ActualMethodWitArgsAndReturn(?List<string> arg1, int arg2)
    {
        return  "";
    }


    /// <summary>
    /// [TODO:description]
    /// </summary>
    public class NestedClass 
    { 
    }
}
