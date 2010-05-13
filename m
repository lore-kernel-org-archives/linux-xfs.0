Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4DE1HWH229189 for <xfs@oss.sgi.com>; Thu, 13 May 2010 09:01:17 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F30A59B4871
	for <xfs@oss.sgi.com>; Thu, 13 May 2010 07:04:03 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id KyxbInlTA3z76upz for
	<xfs@oss.sgi.com>; Thu, 13 May 2010 07:04:03 -0700 (PDT)
Date: Thu, 13 May 2010 16:03:20 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: bad primary superblock - bad magic number !!!
Message-ID: <20100513160320.2a8efc09@galadriel.home>
In-Reply-To: <408113.19031.qm@web112903.mail.gq1.yahoo.com>
References: <28512276.post@talk.nabble.com> <4BE82955.2080009@sandeen.net>
	<978493.86662.qm@web112902.mail.gq1.yahoo.com>
	<20100510222211.3e73cdeb@galadriel.home>
	<132290.52744.qm@web112902.mail.gq1.yahoo.com>
	<20100512142902.47d1022a@harpe.intellique.com>
	<606770.71420.qm@web112907.mail.gq1.yahoo.com>
	<20100513114151.110fe8f9@galadriel.home>
	<408113.19031.qm@web112903.mail.gq1.yahoo.com>
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

Le Thu, 13 May 2010 04:00:33 -0700 (PDT) vous =E9criviez:

> nope, c0d0 represents ( ControllerNumber[c0] LogicalDriveNumber[d0] )
> so its 12 disks in 2 partitions- c0d0 and c0d1
> c0d0 holds configuration information
> I boot from a different device, the raid set is used only for storing
> data.

Oh, OK. I don't understand how a whole array may generate errors. Maybe
the controller's bad then?

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
