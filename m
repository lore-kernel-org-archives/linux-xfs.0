Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Jul 2008 21:52:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6V4qc2s030296
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 21:52:40 -0700
Message-ID: <489146BE.6020308@sgi.com>
Date: Thu, 31 Jul 2008 14:59:42 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.27
References: <20080731025328.6328358C4C3F@chook.melbourne.sgi.com> <20080731034952.GC13395@disturbed>
In-Reply-To: <20080731034952.GC13395@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Dave Chinner wrote:
> On Thu, Jul 31, 2008 at 12:53:28PM +1000, Lachlan McIlroy wrote:
>> The following changes since commit c9272c4f9fbe2087beb3392f526dc5b19efaa56b:
>>   Linus Torvalds (1):
>>         Merge branch 'hotfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6
>>
>> are available in the git repository at:
>>
>>   git://oss.sgi.com:8090/xfs/xfs-pull for-linus
> .....
>> Lachlan McIlroy (11):
>>       [XFS] Use the generic xattr methods.
> .....
>>       [XFS] Use the generic xattr methods.
> 
> BTW, that's a patch from Christoph, so there's a mistake in the
> author of that patch. I don't know why there's duplicates of it
> in the tree - the only thing I can see is that the committer's
> email address is not stable. There is a growing number of
> duplicate commits like this in the XFS tree.....
> 

Yeah I know there are problems with the merge scripts.  Christoph
had already pointed this one out and I thought it had been corrected.
I just don't have the time to fix every commit that comes through.
