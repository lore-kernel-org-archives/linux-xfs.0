Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:12:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97LCqIU026115
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:12:54 -0700
Message-ID: <48EBD12B.6090504@thebarn.com>
Date: Tue, 07 Oct 2008 16:14:19 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: TAKE 957103 - Merge up to 2.6.27-rc8
References: <20081003031258.7886658C52B4@chook.melbourne.sgi.com> <20081003091001.GA11627@infradead.org> <20081003195141.GA18988@infradead.org> <48E96C6B.7000009@sgi.com>
In-Reply-To: <48E96C6B.7000009@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Lachlan McIlroy wrote:
> Christoph Hellwig wrote:
>> On Fri, Oct 03, 2008 at 05:10:01AM -0400, Christoph Hellwig wrote:
>>> So this patch now has made it out to the CVS on oss, but not the actual
>>> update of the surrouding kernel tree.  Any chance to fix that before 
>>> the
>>> weekend so we'll actually have a tree the builds?
>>
>> Ok, everything is fine now.  Looks like the ptools to cvs push being
>> fragile as usual..
>
> Both changes (ie fs/xfs and everything else) went in at the same time.
> Probably just ptools congestion.
>
In terms of ptools the xfs tree and the kernel tree are different "isms"
and therefore are synced up separately from AU to CA via the nirvana 
script,
so who knows what odd timing might have happened with the whole process.

-Russell
