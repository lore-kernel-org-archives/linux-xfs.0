Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5OJpmTT089245 for <xfs@oss.sgi.com>; Sun, 24 Jun 2012 14:51:48 -0500
Received: from vserv.windfluechter.net (vserv.windfluechter.net
	[178.63.83.104]) by cuda.sgi.com with ESMTP id UuV9JkOF8jqb0NBd
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 24 Jun 2012 12:51:46 -0700 (PDT)
Subject: Re: mkfs.xfs states log stripe unit is too large
Mime-Version: 1.0 (Apple Message framework v1084)
From: =?iso-8859-1?Q?Ingo_J=FCrgensmann?= <ij@2012.bluespice.org>
In-Reply-To: <4FE76A50.2010902@hardwarefreak.com>
Date: Sun, 24 Jun 2012 21:51:44 +0200
Message-Id: <563739BF-6A66-41F0-8EA2-CF2171E85B06@2012.bluespice.org>
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
	<20120623234445.GZ19223@dastard> <4FE67970.2030008@sandeen.net>
	<4FE710B7.5010704@hardwarefreak.com>
	<4954261F-D4FB-4589-BE18-2BFCEC05E9B4@2012.bluespice.org>
	<4FE76A50.2010902@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

Am 24.06.2012 um 21:28 schrieb Stan Hoeppner:

> Thus, I'd guess that the metadata format changed from 0.90 to 1.2 with a
> very recent release of mdadm.  Are you using distro supplied mdadm, a
> backported more recent mdadm, or did you build mdadm from the most
> recent source?

As I already wrote, I'm using Debian unstable, therefore distro supplied mdadm. Otherwise I'd have said this. 

> If either of the latter two, don't you think it would have been wise to
> inform us that "hay, I'm using the bleeding edge mdadm just released"?
> Or if you're using a brand new distro release?

I don't think that Debian unstable is bleeding edge. 

I find it strange that you've misinterpreted citing the mdadm man page as "sandbagging us". =:-O

-- 
Ciao...            //      Fon: 0381-2744150
      Ingo       \X/       http://blog.windfluechter.net


gpg pubkey:  http://www.juergensmann.de/ij_public_key.asc

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
