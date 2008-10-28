Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 04:54:08 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9SBrulf022211
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 04:53:56 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by relay1.corp.sgi.com (Postfix) with SMTP id B92258F80B7
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 04:53:49 -0700 (PDT)
Message-ID: <4906EB5B.2020004@sgi.com>
Date: Tue, 28 Oct 2008 21:37:15 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] Urgent queue
References: <20081027133010.GA30607@infradead.org> <20081028064150.GS4985@disturbed>
In-Reply-To: <20081028064150.GS4985@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com



Dave Chinner wrote:
> On Mon, Oct 27, 2008 at 09:30:10AM -0400, Christoph Hellwig wrote:
>> Two patches that are small bugfixes / features that are what I consider the
>> immediately merge queue.
>
> The entire set of 30 patches has passed XFSQA on my test box....

individually (by series) or only after all 30? Bisectability is important,
as Christoph alluded to in another thread. Is the intention to try and take
this lot for 28-rc3? I think Lachlan is now very close to a pull req for
.28, depending on his testing for the memleak and deadlock fixes - time
is now getting pretty short :)

Cheers
-- Mark
