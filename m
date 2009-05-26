Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4QGw7hE152814 for <xfs@oss.sgi.com>; Tue, 26 May 2009 11:58:07 -0500
Received: from smtprelay11.ispgateway.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7603C1A1E92B
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 09:58:18 -0700 (PDT)
Received: from smtprelay11.ispgateway.de (smtprelay11.ispgateway.de
	[80.67.29.28]) by cuda.sgi.com with ESMTP id HpTLSIwGTWiNbL4L
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 09:58:18 -0700 (PDT)
Message-ID: <4A1C1FA9.9080303@cape-horn-eng.com>
Date: Tue, 26 May 2009 18:58:17 +0200
From: Richard Ems <Richard.Ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: Incorrect Free Space / xfs_growfs on RAID5 Volume ?
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
To: xfs@oss.sgi.com, svavar@fiton.is

Hi!

You have hit the 2 TB partition limit.

You will need to change your partitioning to GPT, see
http://en.wikipedia.org/wiki/GUID_Partition_Table or search for "2TB
partition limit" on google.

Backup your data first!

Regards, Richard


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
