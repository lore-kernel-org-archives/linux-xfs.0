Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 17:53:57 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8P0ruj4001584
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 17:53:56 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by relay1.corp.sgi.com (Postfix) with SMTP id 1D7DE8F8055
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 17:55:30 -0700 (PDT)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id KAA23517 for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 10:55:29 +1000
Message-ID: <48DAE39A.7000703@sgi.com>
Date: Thu, 25 Sep 2008 11:04:26 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: TAKE 985583 - make btree tracing generic
References: <20080924074713.2A8EC58C52AE@chook.melbourne.sgi.com> <20080924180540.GA28138@infradead.org> <20080924181722.GA28151@infradead.org>
In-Reply-To: <20080924181722.GA28151@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Wed, Sep 24, 2008 at 02:05:40PM -0400, Christoph Hellwig wrote:
>> This commit forgot to add the new xfs_btree_trace.h file and thus breaks
>> the compile of btree tracing is enabled.
> 
> And xfs_btree_trace.c, too.
> 

Sorry.  Didn't expect any new files.  They're in the tree now. 
