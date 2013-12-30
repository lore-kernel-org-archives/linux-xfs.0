Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2D95229DF8
	for <xfs@oss.sgi.com>; Mon, 30 Dec 2013 11:19:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 109AF304062
	for <xfs@oss.sgi.com>; Mon, 30 Dec 2013 09:19:53 -0800 (PST)
Received: from mail-wg0-f48.google.com (mail-wg0-f48.google.com
	[74.125.82.48]) by cuda.sgi.com with ESMTP id wlaHLGSAWSRYQjWn
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Dec 2013 09:19:38 -0800 (PST)
Received: by mail-wg0-f48.google.com with SMTP id z12so10164280wgg.15
	for <xfs@oss.sgi.com>; Mon, 30 Dec 2013 09:19:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52C0D281.7040704@hardwarefreak.com>
References: <tencent_3F12563342ED1D4E049D1123@qq.com>
	<201312270907.22638.arekm@maven.pl>
	<20131227224212.GK20579@dastard>
	<201312280020.39244.arekm@maven.pl>
	<20131229095033.GL20579@dastard>
	<52C0D281.7040704@hardwarefreak.com>
Date: Mon, 30 Dec 2013 18:19:36 +0100
Message-ID: <CAAxjCEzJOjauTENqGSFyOfqjTWATPg9k2McV0Bx--=QRThhneA@mail.gmail.com>
Subject: Re: [xfs_check Out of memory: ]
From: Stefan Ring <stefanrin@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@oss.sgi.com>

> Now this is an interesting idea Dave.  I hadn't considered temporary
> swap.  Would USB be reliable enough for this?  I've seen lots problem
> reports with folks using USB storage with Linux, random disconnections
> and what not.

I have two plug computers running Linux from external USB disk drive
enclosures for about 3 years, and I've never had the slightest
problem. So it cannot be a fundamental problem.

But exporting over iSCSI is likely the better option anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
