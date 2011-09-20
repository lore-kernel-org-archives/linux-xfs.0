Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8K11PpN024704 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 20:01:25 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E155A174260
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 18:01:24 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id psLVo1UYWEf0BuSz
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 18:01:24 -0700 (PDT)
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
	<C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org>
	<4E6EF274.7050007@profihost.ag>
	<20110913205018.GA8543@infradead.org>
	<4E70571A.80108@profihost.ag> <4E705C42.6020909@profihost.ag>
	<20110914143005.GA28496@infradead.org>
	<4E75B660.1030502@profihost.ag> <20110918230245.GF15688@dastard>
	<1AF8D07B-0E3D-4EF8-A289-12D2339CBADE@profihost.ag>
In-Reply-To: <1AF8D07B-0E3D-4EF8-A289-12D2339CBADE@profihost.ag>
Mime-Version: 1.0 (iPhone Mail 8H7)
Message-Id: <78FA26DA-14C7-4C97-8328-D64C75678CBB@profihost.ag>
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: xfs deadlock in stable kernel 3.0.4
Date: Tue, 20 Sep 2011 03:01:19 +0200
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
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "aelder@sgi.com" <aelder@sgi.com>



Am 20.09.2011 um 02:47 schrieb Stefan Priebe <s.priebe@profihost.ag>:

> I can't get it. It just works on some part. and not on the other.

So works means here reproducing it with bonnie++.

So i can reproduce it still very fast but i don't know how to create a testcase.

Stefan
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
