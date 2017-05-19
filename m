Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from klunky.co.uk ([88.198.95.13]:54211 "EHLO klunky.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750793AbdESLqf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 May 2017 07:46:35 -0400
Subject: Re: xfs delayed logging
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Fri, 19 May 2017 13:46:33 +0200
From: Sophie Loewenthal <sophie@klunky.co.uk>
In-Reply-To: <20170519111204.GA64091@bfoster.bfoster>
References: <b11cf7a2175672631380d44321d77169@klunky.co.uk>
 <20170519111204.GA64091@bfoster.bfoster>
Message-ID: <fe9fb9cc985ad9538e63eecee041583a@klunky.co.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-xfs-owner@vger.kernel.org

Thank-you Brian.

---
 http://blogs.ec.europa.eu/ECintheUK/

On 2017-05-19 13:12, Brian Foster wrote:
> On Fri, May 19, 2017 at 11:43:23AM +0200, Sophie Loewenthal wrote:
>> 
>> Hi,
>> 
>> Is this mount option implemented and what is the syntax?
>> 
>> Reference:
>> https://www.kernel.org/doc/Documentation/filesystems/xfs-delayed-logging-design.txt
>> 
> 
> Delayed logging is core infrastructure and thus has been enabled by
> default for quite some time now. The associated mount options had been
> deprecated and ultimately removed in the following patch:
> 
> commit 93b8a5854f247138e401471a9c3b82ccb62ff608
> Author: Christoph Hellwig <hch@infradead.org>
> Date:   Tue Dec 6 21:58:07 2011 +0000
> 
>     xfs: remove the deprecated nodelaylog option
> ...
> 
> Brian
> 
>> Kind regards, Sophie
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" 
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
