Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2P8ZxHR027981 for <xfs@oss.sgi.com>; Sun, 25 Mar 2012 03:35:59 -0500
Received: from mail.vlasiu.net (mail.vlasiu.net [213.157.175.46]) by
	cuda.sgi.com with ESMTP id pGGXQTR9c32SlRsW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 25 Mar 2012 01:35:56 -0700 (PDT)
Date: Sun, 25 Mar 2012 11:35:46 +0300 (EEST)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: Re: xfs_fsr XFS_IOC_SWAPEXT failed
In-Reply-To: <4F6E4ECA.3020502@sandeen.net>
Message-ID: <alpine.LRH.2.02.1203251134560.14752@mail.vlasiu.net>
References: <alpine.LRH.2.02.1203231552490.21859@mail.vlasiu.net>
	<4F6CD1DC.7010706@sandeen.net>
	<alpine.LRH.2.02.1203232159210.3056@mail.vlasiu.net>
	<4F6CD799.9090903@sandeen.net>
	<alpine.LRH.2.02.1203232220010.4760@mail.vlasiu.net>
	<4F6CE137.3020405@sandeen.net>
	<alpine.LRH.2.02.1203232259450.5980@mail.vlasiu.net>
	<4F6E0D28.7000203@sandeen.net> <4F6E4ECA.3020502@sandeen.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Sat, 24 Mar 2012, Eric Sandeen wrote:

> Short answer is, your file does NOT look corrupted, it's just that the 
> checks in dfrag.c have noticed this obscure bug.
Great! Thank you.
 

Sincerely,
Gabriel

- -- 

// Gabriel VLASIU
//
// OpenGPG-KeyID      : 0xE684206E
// OpenGPG-Fingerprint: 0C3D 9F8B 725D E243 CB3C 8428 796A DB1F E684 206E
// OpenGPG-URL        : http://www.vlasiu.net/public.key


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9u2OIACgkQeWrbH+aEIG7Q8ACcCNZ32VFlpdzZTvAg1LbE2sxz
ZsUAn0uoVHWDwzGstGF+Io8Uqc/s5LPk
=1ZAC
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
