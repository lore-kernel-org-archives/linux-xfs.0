Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Aug 2006 00:46:13 -0700 (PDT)
Received: from mail.rentalia.net (mail.rentalia.com [213.192.209.8])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7H7jwDW021302
	for <xfs@oss.sgi.com>; Thu, 17 Aug 2006 00:45:59 -0700
Message-ID: <44E41E8D.6030105@rentalia.com>
Date: Thu, 17 Aug 2006 09:45:17 +0200
From: Ruben Rubio <ruben@rentalia.com>
MIME-Version: 1.0
Subject: Re: File problem question
References: <44DC44FA.4060401@rentalia.com> <20060814103139.B2698880@wobbly.melbourne.sgi.com> <44E40E50.3070708@rentalia.com>
In-Reply-To: <44E40E50.3070708@rentalia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I think I have found the response.
lastlog is a special "sparse file".

When du -sh command is executed, the space that shows is unreal.
ls -al shows the good one disk usage.

Then, all seems is normal.

Thanks anyway!

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFE5B6NIo1XmbAXRboRAv0SAJ4heBkyh4yavO6Wd4S+H8pAXgR9cQCeJY+0
2W9+TU3/Mf6HQAuwVFNpJ+w=
=d3Cp
-----END PGP SIGNATURE-----
