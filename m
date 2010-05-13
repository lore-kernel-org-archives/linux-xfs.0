Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4D9dsOq216735 for <xfs@oss.sgi.com>; Thu, 13 May 2010 04:39:55 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 964BA128D5FD
	for <xfs@oss.sgi.com>; Thu, 13 May 2010 02:42:40 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id lakIQUiRFsclHfnK for
	<xfs@oss.sgi.com>; Thu, 13 May 2010 02:42:40 -0700 (PDT)
Date: Thu, 13 May 2010 11:41:51 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: bad primary superblock - bad magic number !!!
Message-ID: <20100513114151.110fe8f9@galadriel.home>
In-Reply-To: <606770.71420.qm@web112907.mail.gq1.yahoo.com>
References: <28512276.post@talk.nabble.com> <4BE82955.2080009@sandeen.net>
	<978493.86662.qm@web112902.mail.gq1.yahoo.com>
	<20100510222211.3e73cdeb@galadriel.home>
	<132290.52744.qm@web112902.mail.gq1.yahoo.com>
	<20100512142902.47d1022a@harpe.intellique.com>
	<606770.71420.qm@web112907.mail.gq1.yahoo.com>
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
To: Leo Davis <leo1783@yahoo.com>
Cc: xfs@oss.sgi.com

Le Thu, 13 May 2010 01:38:25 -0700 (PDT) vous =E9criviez:

> /dev/cciss/c0d0: [05/13
> 09:21:08]BadReq:CDB0-15=3D26000C000000A200A000000000000000 ..the spew
> continues..
> =

> =

> Any thoughts here?
> =


If I understand correctly, c0d0 represents a drive (the first one).
Apparently this drive is dead, or close. You should probably ditch it.

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
