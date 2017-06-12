Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50562 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751764AbdFLHqi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jun 2017 03:46:38 -0400
Subject: Re: Request for inclusion of b54554ac5afa ("Make
 __xfs_xattr_put_listen preperly report errors.")
References: <f29b6c4b-3f22-21b1-a02a-5331d22ee485@suse.com>
 <20170612074441.GA9957@kroah.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c5d1b0ad-8bf7-63f2-acf3-325aaa03fe28@suse.com>
Date: Mon, 12 Jun 2017 10:46:35 +0300
MIME-Version: 1.0
In-Reply-To: <20170612074441.GA9957@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, darrick.wong@oracle.com, asavkov@redhat.com



On 12.06.2017 10:44, Greg KH wrote:
> On Mon, Jun 12, 2017 at 10:24:16AM +0300, Nikolay Borisov wrote:
>> Hello,
>>
>> I'd like to request the inclusion of the aforementioned patch. It is
>> needed as an addition to 2a6fba6d2311 ("xfs: only return -errno or
>> success from attr ->put_listent") which was already included in 4.4.71.
> 
> What kernel tree(s) do you wish to see this included in?

Oh, sorry for missing this out, this needs to be included from 4.4 onwards.

> 
> thanks,
> 
> greg k-h
> 
