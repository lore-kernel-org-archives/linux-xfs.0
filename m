Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54264 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731863AbeGaAVq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jul 2018 20:21:46 -0400
Subject: Re: Clearly state infrastructure change on old XFS website
References: <4b3ef7f54f32dc2b61a5d4a33a0e5b2e@wh2.tu-dresden.de>
 <20180730223042.GC4226@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3f708cdb-4cb0-dd12-0483-ada1025364b9@sandeen.net>
Date: Mon, 30 Jul 2018 17:44:35 -0500
MIME-Version: 1.0
In-Reply-To: <20180730223042.GC4226@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, adam_kalisz <adam_kalisz@wh2.tu-dresden.de>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 7/30/18 5:30 PM, Darrick J. Wong wrote:
> On Sat, Jul 28, 2018 at 11:25:40PM +0200, adam_kalisz wrote:
>> Dear Darrick,
>>
>> I wanted to have a look at the recent new features being added to XFS and
>> stumbled on the fact, that Google presents me first with the old website [0]
>> and starting on page 2 of the web results (for the desperate) with the
>> current website [1].
>>
>> It would be most helpful to write some notice to the old website and the
>> "Getting the latest source code" should point to the current git-repo. It
>> cost me some time to realize, there is something wrong, because the git log
>> ended at about 4.9 kernel (~2016) when the infrastructure from sgi probably
>> got left behind. Also maybe highlight, that the current repo ist xfs-linux
>> and NOT linux-xfs! It might help some of your possible future colleagues to
>> get started with XFS.
> 
> Sorry about that -- I'll ask those who have write access to xfs.org to
> update the links.  In the long run I'd rather just move all the
> documentation and FAQ into the kernel source itself, especially since it
> all now lives on https://www.kernel.org/doc/html/latest/ ...

yeah ...

As a general PSA, the wiki is known to be bitrotting.  It's impossible to add
new editors, for example.  It'll eventually probably go away entirely.

I've fixed up a couple things Darrick asked me to do, but maybe we should
just put a big <blink>THIS WIKI IS BITROTTING</blink> at the top and be
done with it.

-Eric

> --D
> 
>> TL;DR:
>> Please make sure the XFS development is more visible by ensuring that most
>> prominent references point to the current repository and website.
>>
