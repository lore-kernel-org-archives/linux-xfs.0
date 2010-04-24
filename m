Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3OLAiVa184154 for <xfs@oss.sgi.com>; Sat, 24 Apr 2010 16:10:44 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3664D2EC1E1
	for <xfs@oss.sgi.com>; Sat, 24 Apr 2010 14:12:43 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id e8DMbOjuUrP2yWSd for
	<xfs@oss.sgi.com>; Sat, 24 Apr 2010 14:12:43 -0700 (PDT)
Date: Sat, 24 Apr 2010 23:12:23 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: power failure causes files loss
Message-ID: <20100424231223.39b12239@galadriel.home>
In-Reply-To: <201004241905.44282.hpj@urpla.net>
References: <28340118.post@talk.nabble.com> <4BD21E65.80203@hardwarefreak.com>
	<201004241905.44282.hpj@urpla.net>
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
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: adamantzj <tzj1983@163.com>, Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

Le Sat, 24 Apr 2010 19:05:43 +0200 vous =E9criviez:

> that any storage based filesystems  =

> should stay consistent _any_ time

AFAIK only FreeBSD UFS-with soft-updates actually comes close to that,
at the huge cost of being impossibly complex :)

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
