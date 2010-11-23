Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANMkit8020322 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 16:46:44 -0600
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5834013E59DF
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 14:48:19 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id u7tIGByHQ1aYOUWX for
	<xfs@oss.sgi.com>; Tue, 23 Nov 2010 14:48:19 -0800 (PST)
Date: Tue, 23 Nov 2010 23:48:11 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Xfs delaylog hanged up
Message-ID: <20101123234811.0ea3c41c@galadriel.home>
In-Reply-To: <20101123204609.GW22876@dastard>
References: <4CEAC412.9000406@shiftmail.org> <20101122232929.GJ13830@dastard>
	<4CEBA2D5.2020708@shiftmail.org> <20101123204609.GW22876@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Spelic <spelic@shiftmail.org>

Le Wed, 24 Nov 2010 07:46:09 +1100 vous =E9criviez:

> Hmmmm. We get plenty of reports about problems with 3ware RAID
> controllers, many of which are RAID controller problems. Can you
> make sure you are running the latest firmware on the controller?

So Spelic, you're using the 3Ware as a SATA controller, but not a RAID
controller? This is quite unexpected, though going with md
instead provides better IOPS. =


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
