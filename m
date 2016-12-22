Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37708 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752839AbcLVPJ2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Dec 2016 10:09:28 -0500
Subject: Re: [PATCH v3] Fix building xfsprogs on 32-bit platforms
References: <20161221190413.GA136777@gmail.com>
 <1a75e88c-014c-b245-2271-f7d201da1285@sandeen.net>
 <20161222085804.GB23054@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <61a082d0-c974-bcdc-196f-ea13004c484b@sandeen.net>
Date: Thu, 22 Dec 2016 09:09:26 -0600
MIME-Version: 1.0
In-Reply-To: <20161222085804.GB23054@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, Eric Biggers <ebiggers@google.com>, Felix Janda <felix.janda@posteo.de>



On 12/22/16 2:58 AM, Christoph Hellwig wrote:
> On Wed, Dec 21, 2016 at 03:33:11PM -0600, Eric Sandeen wrote:
>> TBH I haven't really tested this on a 32-bit system yet,
>> I'm sorry.  Right now, I plan to get it into the tree right
>> after we cut the next release this week.
> 
> It would be useful to have it in the release to avoid a regression.

Fair point.  Dave was trying to keep changes down and get a tagged
release out soon, but we certainly shouldn't regress this.
I'll see about getting it in.

Thanks,
-Eric
