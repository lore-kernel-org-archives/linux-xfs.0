Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jun 2008 10:14:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5GHEF9m020730
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 10:14:15 -0700
Received: from ext.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7130239F0F
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 10:15:13 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177]) by cuda.sgi.com with ESMTP id mUvCeC4VRAxsGXmp for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 10:15:13 -0700 (PDT)
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id m5GHEo8Z018114
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 10:14:50 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id m5GHEone015257
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 10:14:50 -0700
From: Dave Chinner <dchinner@agami.com>
Subject: Re: [PATCH] kill XFS_PURGE_INODE
Date: Mon, 16 Jun 2008 10:15:12 -0700
References: <20080616062634.GA5971@lst.de>
In-Reply-To: <20080616062634.GA5971@lst.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806161015.12363.dchinner@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sunday 15 June 2008 11:26 pm, Christoph Hellwig wrote:
> Just a useless alias for IRELE.

Looks sane.

Cheers,

Dave.
