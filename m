Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38940 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755273AbdEKSRF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 14:17:05 -0400
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
References: <20170509122219.31756-1-rgoldwyn@suse.de>
 <20170509122219.31756-6-rgoldwyn@suse.de>
 <20170511074451.GD15626@infradead.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <7653c93d-df5c-fc87-cfdd-051dd33c11fb@suse.de>
Date: Thu, 11 May 2017 13:16:57 -0500
MIME-Version: 1.0
In-Reply-To: <20170511074451.GD15626@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>



On 05/11/2017 02:44 AM, Christoph Hellwig wrote:
> Looks fine,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Although lifting the make_request limit is something a lot of users
> would appreciate in the near future..
> 

Yes, I understand. That will be on my todo list next on priority.

-- 
Goldwyn
