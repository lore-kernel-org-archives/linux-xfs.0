Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8041 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbfAQRce (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 12:32:34 -0500
Subject: Re: [PATCH] iomap: get/put the page in iomap_page_create/release()
References: <20190115211028.15742-1-hch@lst.de>
 <20190115230744.GM4205@dastard> <20190117075145.GA29509@lst.de>
From: Piotr Jaroszynski <pjaroszynski@nvidia.com>
Message-ID: <5777f872-49a9-2717-a0c1-664908aeb8e1@nvidia.com>
Date: Thu, 17 Jan 2019 09:32:32 -0800
MIME-Version: 1.0
In-Reply-To: <20190117075145.GA29509@lst.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 1/16/19 11:51 PM, Christoph Hellwig wrote:
> On Wed, Jan 16, 2019 at 10:07:45AM +1100, Dave Chinner wrote:
>> Missing a SOB.
>>
>> But apart from that, I've been running an identical patch in my test
>> tree, so:
> 
> Piotr: do you still want to claim authorship for this fixed up patch,
> in which case I'll need your sob.  Otherwise I can submit it under my
> name.

Sorry for the delay and thank you for handling the revert while I was
out on paternity leave. I'm fine with whatever is easiest for you,
and thanks for fixing up the patch!

Thanks,
Piotr
