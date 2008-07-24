Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 01:14:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6O8EqmP031086
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 01:14:53 -0700
Message-ID: <48883B8B.9090802@sgi.com>
Date: Thu, 24 Jul 2008 18:21:31 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] implement IHOLD/IRELE directly
References: <20080723194950.GF6188@lst.de> <20080723225548.GO6761@disturbed> <20080724062220.GB26938@lst.de> <20080724080727.GA31612@lst.de>
In-Reply-To: <20080724080727.GA31612@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Thu, Jul 24, 2008 at 08:22:20AM +0200, Christoph Hellwig wrote:
>> Makes sense, updated patch below.  (Half-way through xfsqa with a debug
>> kernel so far)
> 
> xfsqa passed fine with this patch applied.
> 
Great.  All five patches look good to me.  I'll get them into the tree tomorrow.
