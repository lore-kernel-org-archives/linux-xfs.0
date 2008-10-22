Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 22:22:53 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9M5Mn59024288
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 22:22:49 -0700
Message-ID: <48FEB910.4020500@sgi.com>
Date: Wed, 22 Oct 2008 16:24:32 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] use proper mnt_want_write calls for handle ioctls
References: <20080814203952.GB18704@lst.de> <20080912084431.GA22641@lst.de> <20080929074234.GA23785@lst.de> <20081018123739.GC25304@lst.de>
In-Reply-To: <20081018123739.GC25304@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Ping again.  As said before this could cause filesystem corruption with
> the SGI tree, and it's always been correct in mainline there shouldn't
> be any reason to delay it.

Done
