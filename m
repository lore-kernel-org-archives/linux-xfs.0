Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 05 Oct 2008 18:29:00 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m961SrEf004054
	for <xfs@oss.sgi.com>; Sun, 5 Oct 2008 18:28:53 -0700
Message-ID: <48E96C6B.7000009@sgi.com>
Date: Mon, 06 Oct 2008 11:39:55 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: TAKE 957103 - Merge up to 2.6.27-rc8
References: <20081003031258.7886658C52B4@chook.melbourne.sgi.com> <20081003091001.GA11627@infradead.org> <20081003195141.GA18988@infradead.org>
In-Reply-To: <20081003195141.GA18988@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Oct 03, 2008 at 05:10:01AM -0400, Christoph Hellwig wrote:
>> So this patch now has made it out to the CVS on oss, but not the actual
>> update of the surrouding kernel tree.  Any chance to fix that before the
>> weekend so we'll actually have a tree the builds?
> 
> Ok, everything is fine now.  Looks like the ptools to cvs push being
> fragile as usual..

Both changes (ie fs/xfs and everything else) went in at the same time.
Probably just ptools congestion.
