Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4L8O1HS090166 for <xfs@oss.sgi.com>; Mon, 21 May 2012 03:24:02 -0500
Received: from mail.linuxsystems.it (mail.linuxsystems.it [2.119.245.41]) by
	cuda.sgi.com with ESMTP id C1fX6SQBH8ohIqsA for
	<xfs@oss.sgi.com>; Mon, 21 May 2012 01:24:00 -0700 (PDT)
Received: from [IPv6:2a01:7e00:e001:303:222:faff:fe19:f312] (unknown
	[IPv6:2a01:7e00:e001:303:222:faff:fe19:f312])
	by mail.linuxsystems.it (Postfix) with ESMTPSA id 56B4F5B35
	for <xfs@oss.sgi.com>; Mon, 21 May 2012 10:23:58 +0200 (CEST)
Message-ID: <4FB9FB9E.6050705@linuxsystems.it>
Date: Mon, 21 May 2012 10:23:58 +0200
From: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
MIME-Version: 1.0
Subject: Re: How to recover data from an xfs partition
References: <4FAE9DBF.1090505@linuxsystems.it> <4FB68AF6.1090303@sandeen.net>
	<4FB6B7AB.8030405@linuxsystems.it> <2867697.yP7s3MR3RI@saturn>
In-Reply-To: <2867697.yP7s3MR3RI@saturn>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Il 21/05/2012 09:44, Michael Monnerie ha scritto:
> Shouldn't that be sync, remount r/o, reboot instead? If you remount r/o,
> the cache in the system wouldn't be written anymore.

Yes, that's what I did (S,U,B).

Niccol=F2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
