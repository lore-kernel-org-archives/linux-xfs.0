Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2NK22eA006084 for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 15:02:02 -0500
Received: from mail.vlasiu.net (mail.vlasiu.net [213.157.175.46]) by
	cuda.sgi.com with ESMTP id bI4DlM7c6xxmFIBX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Mar 2012 13:02:00 -0700 (PDT)
Date: Fri, 23 Mar 2012 22:01:50 +0200 (EET)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: Re: xfs_fsr XFS_IOC_SWAPEXT failed
In-Reply-To: <4F6CD1DC.7010706@sandeen.net>
Message-ID: <alpine.LRH.2.02.1203232159210.3056@mail.vlasiu.net>
References: <alpine.LRH.2.02.1203231552490.21859@mail.vlasiu.net>
	<4F6CD1DC.7010706@sandeen.net>
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

On Fri, 23 Mar 2012, Eric Sandeen wrote:

> Check kernel logs / dmesg?
xfs_swap_extents: inode 0x400dd2e4 format is incompatible for exchanging.

Also xfs_repair does not report anything wrong.


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

iEYEARECAAYFAk9s1q4ACgkQeWrbH+aEIG7cbQCggnj+KBd/DNaqIslz7hu/uprI
VvYAniFH5PPOhbMCpEuzrsa5v4s+nzMm
=8WGr
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
