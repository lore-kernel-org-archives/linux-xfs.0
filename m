Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NFPbX1208053 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 10:25:38 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2FC51132D6AE
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 08:35:36 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id QgUe0qiYvlLdSOG5 for
	<xfs@oss.sgi.com>; Fri, 23 Jul 2010 08:35:36 -0700 (PDT)
Date: Fri, 23 Jul 2010 17:28:38 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: 4k sector drives
Message-ID: <20100723172838.3b40a745@harpe.intellique.com>
In-Reply-To: <201007231802.11491.eye.of.the.8eholder@gmail.com>
References: <201007231802.11491.eye.of.the.8eholder@gmail.com>
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
To: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Cc: xfs@oss.sgi.com

Le Fri, 23 Jul 2010 18:02:11 +0300
Khelben Blackstaff <eye.of.the.8eholder@gmail.com> =E9crivait:

> It hurts a lot. On my 1TB EARS when i was benchmarking unaligned
> partitions, untarring a linux kernel for example took ages. (tar
> output finished quickly but then you had to wait a long time till the
> shell prompt returns)

Extracting a linux tarball creates lots of very small files, so it is
expected to perform very badly on unaligned partitions. But I suppose
that copying the tarball itself to the disk could be only slightly
slower than normal.

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
