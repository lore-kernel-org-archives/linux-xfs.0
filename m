Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5IDxIcB226933 for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 08:59:18 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17F833E3855
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 07:01:54 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 6lJvb0ibdjfQR1SY for
	<xfs@oss.sgi.com>; Fri, 18 Jun 2010 07:01:54 -0700 (PDT)
Date: Fri, 18 Jun 2010 16:01:52 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Help with XFS
Message-ID: <20100618160152.77dfb143@harpe.intellique.com>
In-Reply-To: <OF752A728E.086B0B19-ONC1257746.00484C47-C1257746.004AACED@bergenofs.no>
References: <OF4967B99D.609CC213-ONC1257745.0048E646-C1257745.004919A3@bergenofs.no>
	<20100618132108.790921cf@harpe.intellique.com>
	<OF450B8187.BD5256B0-ONC1257746.003E79FF-C1257746.003EE62C@bergenofs.no>
	<20100618133458.6640ce96@harpe.intellique.com>
	<OF0E234D8E.F048FF4D-ONC1257746.003FC10E-C1257746.00407333@bergenofs.no>
	<20100618140028.05650928@harpe.intellique.com>
	<OF9654ECF8.CC8A338F-ONC1257746.00437A9B-C1257746.004384E1@bergenofs.no>
	<20100618150848.289428ed@harpe.intellique.com>
	<OF752A728E.086B0B19-ONC1257746.00484C47-C1257746.004AACED@bergenofs.no>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Thomas =?ISO-8859-1?Q?F=F8rde?= <thomas.forde@bergenofs.no>
Cc: xfs@oss.sgi.com

Le Fri, 18 Jun 2010 15:35:39 +0200
Thomas F=F8rde <thomas.forde@bergenofs.no> =E9crivait:

> testrun of xfs_irecover
> =

> =

> error while loading shard libraries: libHX.so.22, cannot open shared =

> object file, no such file or directory.
> =

> prolly some libs at the wrong place point elsewhere.
> =


What version of libhx did you install and how? I've finally managed to
compile xfs_irecover by using libhx18.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
