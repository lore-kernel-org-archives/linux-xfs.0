Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Dec 2006 03:07:41 -0800 (PST)
Received: from deliver.uni-koblenz.de (deliver.uni-koblenz.de [141.26.64.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBFB7Xqw024072
	for <xfs@oss.sgi.com>; Fri, 15 Dec 2006 03:07:34 -0800
Received: from localhost (localhost [127.0.0.1])
	by deliver.uni-koblenz.de (Postfix) with ESMTP id BC15DB8F81B
	for <xfs@oss.sgi.com>; Fri, 15 Dec 2006 11:36:49 +0100 (CET)
Received: from deliver.uni-koblenz.de ([127.0.0.1])
 by localhost (deliver [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 02698-09 for <xfs@oss.sgi.com>; Fri, 15 Dec 2006 11:36:47 +0100 (CET)
Received: from bliss.uni-koblenz.de (bliss.uni-koblenz.de [141.26.64.65])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by deliver.uni-koblenz.de (Postfix) with ESMTP id C14C8B8FAD3
	for <xfs@oss.sgi.com>; Fri, 15 Dec 2006 11:36:47 +0100 (CET)
From: Rainer Krienke <krienke@uni-koblenz.de>
Subject: LEAFN node level is 1 warning in xfs_repair
Date: Fri, 15 Dec 2006 11:36:46 +0100
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7248808.pHeuGFeSMS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200612151136.47182.krienke@uni-koblenz.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--nextPart7248808.pHeuGFeSMS
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

I have a xfs filesystem on a SuSE SLES10 (kernel 2.6.16.21) system that was=
=20
created just a week ago. Because I wanted to know how long it might take to=
=20
run xfs_repair in case it might be needed I started xfs_repair on it withou=
t=20
that I thought I would actually need it.

Now for several inodes xfs_repair reports in Phase 3 and 4=20

LEAFN node level is 1=20

warning. In the mailinglists I found that other people have the same=20
experience.=20

The question is, if this warning anything serious that might lead into a=20
filesystem corruption later. Or can I just forget about this warning?

Thanks
Rainer
--=20
---------------------------------------------------------------------------
Rainer Krienke, Universitaet Koblenz, Rechenzentrum, Raum A022
Universitaetsstrasse 1, 56070 Koblenz, Tel: +49 261287 -1312, Fax: -1001312
Mail: krienke@uni-koblenz.de, Web: http://www.uni-koblenz.de/~krienke
Get my public PGP key: http://www.uni-koblenz.de/~krienke/mypgp.html
---------------------------------------------------------------------------

--nextPart7248808.pHeuGFeSMS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBFgnq/aldtjc/KDEoRAqufAJ45aPnItnLemRloOImjo7UsSItUDwCdHfF/
nk4IjD0bcpxkYxF1+qyydVQ=
=Y2X/
-----END PGP SIGNATURE-----

--nextPart7248808.pHeuGFeSMS--
