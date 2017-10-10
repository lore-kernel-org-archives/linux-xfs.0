Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40994 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755853AbdJJDHN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Oct 2017 23:07:13 -0400
Subject: Re: [PATCH] xfs: handle error if xfs_btree_get_bufs fails
References: <20171010021949.GB8049@wotan.suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a0eaaf24-75cf-19c4-c287-2445eae6fc70@sandeen.net>
Date: Mon, 9 Oct 2017 22:07:12 -0500
MIME-Version: 1.0
In-Reply-To: <20171010021949.GB8049@wotan.suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, gfigueira@suse.com, tetsuya.inoue@suse.com



On 10/9/17 9:19 PM, Luis R. Rodriguez wrote:
> What ever happened to this patch [0]? It was ACKed [1] 

(it was reviewed-by hch)

> but I haven't
> seen it merged. Did it fall through the cracks?

Seems like it, possibly because I sent V2 as a re:, accidentally.

-Eric
 
> [0] https://patchwork.kernel.org/patch/9486811/
> [1] https://www.spinics.net/lists/linux-xfs/msg02818.html
> 
>   Luis
