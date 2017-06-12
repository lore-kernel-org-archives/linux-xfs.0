Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39127 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751494AbdFLMkL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jun 2017 08:40:11 -0400
Subject: Re: Request for inclusion of b54554ac5afa ("Make
 __xfs_xattr_put_listen preperly report errors.")
References: <f29b6c4b-3f22-21b1-a02a-5331d22ee485@suse.com>
 <20170612123312.GD17001@kroah.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a59171e2-9962-00c6-977f-45b668ca96c6@suse.com>
Date: Mon, 12 Jun 2017 15:40:08 +0300
MIME-Version: 1.0
In-Reply-To: <20170612123312.GD17001@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, darrick.wong@oracle.com, asavkov@redhat.com



On 12.06.2017 15:33, Greg KH wrote:
> On Mon, Jun 12, 2017 at 10:24:16AM +0300, Nikolay Borisov wrote:
>> Hello,
>>
>> I'd like to request the inclusion of the aforementioned patch.
> 
> What patch?  Commit b54554ac5afa is not in any kernel tree that I can
> find :(

Yeah, I tested this particular patch but I might have copied the ID from
an internal tree. The upstream patch is:

791cc43b36eb ("Make __xfs_xattr_put_listen preperly report errors.")

It's a single one-liner and it applies cleanly on 4.4

> 
> Are you sure you tested this?  :(
> 
> greg k-h
> 
