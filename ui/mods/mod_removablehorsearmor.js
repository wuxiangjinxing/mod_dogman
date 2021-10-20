"use strict";
{
  var connect = CharacterScreenDatasource.prototype.onConnection, hooked = false;
  CharacterScreenDatasource.prototype.onConnection = function(handle)
  {
    connect.bind(this)(handle);
    if(!hooked)
    {
      this.addListener(CharacterScreenDatasourceIdentifier.Brother.Selected, function(ds, bro)
      {
        if(bro !== null && ds.mSQHandle !== null && CharacterScreenIdentifier.Entity.Id in bro)
        {
          SQ.call(ds.mSQHandle, '_aa_onBrotherSelected', bro[CharacterScreenIdentifier.Entity.Id]);
        }
      });
      hooked = true;
    }
  }
}
