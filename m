Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB7Lom7M228447 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 15:50:49 -0600
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BA121426BA0
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 13:52:33 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id us05kPch6PutdLK5 for
	<xfs@oss.sgi.com>; Tue, 07 Dec 2010 13:52:33 -0800 (PST)
Date: Tue, 7 Dec 2010 22:52:26 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: kernel panic-xfs errors
Message-ID: <20101207225226.55be2b4d@galadriel.home>
In-Reply-To: <4CFE7A89.2010307@hardwarefreak.com>
References: <30397503.post@talk.nabble.com>
	<20101207165917.0c96dd95@harpe.intellique.com>
	<30398448.post@talk.nabble.com>
	<20101207190038.61e9dbb7@harpe.intellique.com>
	<4CFE7A89.2010307@hardwarefreak.com>
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

Le Tue, 07 Dec 2010 12:18:49 -0600 vous =E9criviez:

> The answer for the one server is simple:  back out the firmware--flash
> it with the previously installed version.
> =

> BTW, what need prompted the new flash in the first place?  I _never_
> flash controller firmware unless absolutely necessary.  You've
> demonstrated today why I practice that faith.

I've experienced myself some very convincing reasons, for instance a
RAID array with a performance varying by 1000% with a new firmware.

However the kernel panic occured on another that apparently wasn't
firmware-flashed.

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
