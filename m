Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EKVOnn146993 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 15:31:24 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA46917E5ABF
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 13:32:11 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id 7kQtXEmw55pmrzsp for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 13:32:11 -0700 (PDT)
Date: Tue, 14 Sep 2010 22:32:01 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Now: Debian issues, WAS: XFS Filesystem not mounting
Message-ID: <20100914223201.21c3bd0f@galadriel.home>
In-Reply-To: <4C8FB8D6.6080603@hardwarefreak.com>
References: <29704010.post@talk.nabble.com> <20100914012151.GF411@dastard>
	<29705139.post@talk.nabble.com> <201009140740.14482@zmi.at>
	<20100914082504.4109712d@galadriel.home>
	<29708085.post@talk.nabble.com> <201009141603.24754@zmi.at>
	<4C8F9E29.2000803@hardwarefreak.com>
	<29710491.post@talk.nabble.com>
	<4C8FB8D6.6080603@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

Le Tue, 14 Sep 2010 13:03:02 -0500 vous =E9criviez:

> > ;-)  That makes a huge difference.  But generally my experience
> > thus far with debian has been positive.  Enough to make me consider
> > switching.   And I know the XFS has never given me a lick of
> > trouble.  =

> =

> I've only been using XFS for about a year now, and I've had zero
> problems. =


I've used XFS only since 1996 and never looked back - I
still actually miss those sturdy Origin 200 and 2000 :) I've set up
about 2.5 PB of XFS filesystems in the past 5 years so I think it's
quite a significant metric.

On the other hand I had some problems (fortunately nothing
irremediable) on reiser, ext3 though I used them only sparsely.
Obviously XFS is much more resilient to hardware glitches (I even
recovered most of the data from a RAID-0 array with a failed drive).

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
