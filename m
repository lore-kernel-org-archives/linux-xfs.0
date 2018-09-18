Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58800 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727140AbeISAgs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 20:36:48 -0400
Subject: Re: [ANNOUNCE] xfsprogs libxfs-4.19-sync branch pushed
References: <d461e927-5b07-c72b-9dac-c82a4336a272@sandeen.net>
 <20180918184800.GF20086@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8df51bc3-aa09-d45c-7db7-3b30cb2abcaa@sandeen.net>
Date: Tue, 18 Sep 2018 14:02:49 -0500
MIME-Version: 1.0
In-Reply-To: <20180918184800.GF20086@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 9/18/18 1:48 PM, Darrick J. Wong wrote:
> On Mon, Sep 17, 2018 at 09:16:10PM -0500, Eric Sandeen wrote:
>> Hi all -
>>
>> Sorry for the delay, but a preliminary libxfs-4.19-sync branch has
>> been pushed up to the xfsprogs repository on kernel.org.  The 
>> top commit is
>>
>> The head of the libxfs-4.19-sync branch is commit:
>>
>> b53f016 xfs: fix a null pointer dereference in xfs_bmap_extents_to_btree
>>
>> This passed basic sanity checks, now I'll go see what all differs
>> in Darrick's tree that he did similar work in ~1 month ago...
> 
> <urk> I had a bunch of cleanups for the userspace transaction code that
> wanted to go in before the merge... sigh.
> 
> Well I guess I'll send them as a start and we can decide what to do about it.
>

No problem, I'll get it sorted.  These libxfs sync branches are /totally/
rebaseable ...


Thanks for the updates!

-Eric
