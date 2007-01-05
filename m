Return-Path: <chatz@melbourne.sgi.com>
Message-ID: <459EC918.7090702@melbourne.sgi.com>
Date: Sat, 06 Jan 2007 08:54:32 +1100
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
MIME-Version: 1.0
Subject: Re: merged patches
References: <458AFA34.1000100@sandeen.net> <459EA308.6040809@sgi.com>
In-Reply-To: <459EA308.6040809@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: lachlan@sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-dev@sgi.com
List-ID: <xfs>

Lachlan,

I think this page
http://asg.melbourne.sgi.com/xfs/rampup/xfs_to_linus.shtml
needs to rewritten to make it clear about
- signed off by
- the one line at the start of the overall change description
- cc'ing xfs@oss.sgi.com
- anything else?

The title of the page is not right either, we have other pages now
describing how to push stuff to linus, and others talking about how to
use git.

Could you have a go at this?

Thanks,

David


Lachlan McIlroy wrote:
> Eric Sandeen wrote:
>> Hi Lachlan, thanks for merging some of my tidy-up patches.  :)
>>
>> A couple things -
>>
>> I never saw the take messages go by the external list, just noticed them
>> after a cvs update and an attempt to sync up my patchset.  Can you guys
>> please send the take messages externally too?  It makes it much easier
>> to keep up with what's going on, for those interested.
> I sent the TAKE messages to xfs@oss.sgi.com, xfs-dev@sgi.com and to
> Bugworks.  We've had problems with email traffic to oss disappearing
> or taking up to 4 weeks to appear!
> 
>>
>> Also, please don't strip out the Signed-off-by: lines in contributed
>> patches; that authorship information should stay with the patch.  Feel
>> free to add signed-off-by or reviewed-by but the original signed-off-by
>> line shouldn't be removed...
> Sorry about that, I didn't know about the signed-off-by thingy.

-- 
David Chatterton
XFS Engineering Manager
SGI Australia
