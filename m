Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 01:06:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6O86R4i029919
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 01:06:27 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4DD931FD76
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 01:07:37 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Cf9TOO8K15C7NCYj for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 01:07:37 -0700 (PDT)
Date: Thu, 24 Jul 2008 10:07:27 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/5] implement IHOLD/IRELE directly
Message-ID: <20080724080727.GA31612@lst.de>
References: <20080723194950.GF6188@lst.de> <20080723225548.GO6761@disturbed> <20080724062220.GB26938@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724062220.GB26938@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Jul 24, 2008 at 08:22:20AM +0200, Christoph Hellwig wrote:
> Makes sense, updated patch below.  (Half-way through xfsqa with a debug
> kernel so far)

xfsqa passed fine with this patch applied.
