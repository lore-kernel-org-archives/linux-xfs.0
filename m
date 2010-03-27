Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2R94pTJ069163 for <xfs@oss.sgi.com>; Sat, 27 Mar 2010 04:04:51 -0500
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 401C61A63CEE
	for <xfs@oss.sgi.com>; Sat, 27 Mar 2010 02:06:31 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id oVEgzZ8nL6x5StG8 for
	<xfs@oss.sgi.com>; Sat, 27 Mar 2010 02:06:31 -0700 (PDT)
Date: Sat, 27 Mar 2010 10:06:18 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: 128TB filesystem limit?
Message-ID: <20100327100618.71e24a0a@galadriel.home>
In-Reply-To: <alpine.DEB.2.00.1003251609160.12435@asgard.lang.hm>
References: <alpine.DEB.2.00.1003251609160.12435@asgard.lang.hm>
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
To: david@lang.hm
Cc: xfs@oss.sgi.com

Le Thu, 25 Mar 2010 16:15:42 -0700 (PDT) vous =E9criviez:

> is this just rounding error combined with the 1000=3D1k vs 1024=3D1k
> marketing stuff, or is there some limit I am bumping into here.

This isn't an xfs limit, I've set up several hundred big xfs FS for
more than 5 years (13 to 76 TB) and never saw that. It must be a bug in
df or elsewhere. What distribution is this? and architecture?

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
