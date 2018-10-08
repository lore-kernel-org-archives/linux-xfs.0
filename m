Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42646 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbeJHWKP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Oct 2018 18:10:15 -0400
Subject: Re: [PATCH 01/15] xfsprogs: minor sparse fixes
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
 <1538712196-13625-2-git-send-email-sandeen@sandeen.net>
 <20181006100727.GA28114@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8b359bfd-c51c-fd9c-0a2e-6476cd33d441@sandeen.net>
Date: Mon, 8 Oct 2018 09:58:06 -0500
MIME-Version: 1.0
In-Reply-To: <20181006100727.GA28114@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org



On 10/6/18 5:07 AM, Christoph Hellwig wrote:
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Why the double signoff?
> 

pilot error, it passed through two of my machines with
git set up differently.

I tend to use @redhat.com as my author email but @sandeen.net
as my maintainer email.  I didn't really mean to have both in
these patches in this way.

-Eric
