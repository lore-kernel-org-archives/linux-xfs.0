Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from a4-5.smtp-out.eu-west-1.amazonses.com ([54.240.4.5]:45652 "EHLO
        a4-5.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751821AbeA0RFc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Jan 2018 12:05:32 -0500
Subject: Re: [RFD] XFS: Subvolumes and snapshots....
References: <20180125055144.qztiqeakw4u3pvqf@destitution>
From: Martin Raiber <martin@urbackup.org>
Message-ID: <010201613894cb3c-2d39d6ae-57f4-468c-a50c-5f44fda73f5b-000000@eu-west-1.amazonses.com>
Date: Sat, 27 Jan 2018 17:05:31 +0000
MIME-Version: 1.0
In-Reply-To: <20180125055144.qztiqeakw4u3pvqf@destitution>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 25.01.2018 06:51 Dave Chinner wrote:
> The video from my talk at LCA 2018 yesterday about the XFS subvolume and
> snapshot support I'm working on has been uploaded and can be found
> here:
>
> https://www.youtube.com/watch?v=wG8FUvSGROw
>
> I don't have the code in a reviewable form yet - there's still quite
> a bit of work before I get to that point, but this is a good
> introduction to how all the pieces will fit together....

Great talk!

I'm pretty sure it's hard to add, but cross-subvolume reflinks would be
something useful for my use case.

