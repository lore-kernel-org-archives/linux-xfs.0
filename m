Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:53707 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752709AbeDROXn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Apr 2018 10:23:43 -0400
Received: by mail-it0-f54.google.com with SMTP id m134-v6so2771197itb.3
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 07:23:43 -0700 (PDT)
Subject: Re: [PATCH 3/4] blk: add blk_queue_fua() helper function
References: <20180418040828.18165-1-david@fromorbit.com>
 <20180418040828.18165-4-david@fromorbit.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <7f399e07-b0e6-4f6e-9d3c-2eeac3d070ec@kernel.dk>
Date: Wed, 18 Apr 2018 08:23:40 -0600
MIME-Version: 1.0
In-Reply-To: <20180418040828.18165-4-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

On 4/17/18 10:08 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So we can check FUA support status from the iomap direct IO code.

Applied, thanks.

-- 
Jens Axboe

