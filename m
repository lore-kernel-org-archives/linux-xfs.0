Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750799AbdGNIuU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jul 2017 04:50:20 -0400
Date: Fri, 14 Jul 2017 10:50:16 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Parent pointers
Message-ID: <20170714085016.4j2yeyihezmb6nkp@eorzea.usersys.redhat.com>
References: <59680165.9020201@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59680165.9020201@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

Hi,

On Thu, Jul 13, 2017 at 04:25:25PM -0700, Allison Henderson wrote:
> Hi all,
> 
> I've been doing some digging on adding parent pointers to xfs and wanted to
> send a note to folks here to get peoples opinions on it.

Are you talking about parent pointers in the BTrees?



> I got in touch
> with Brian Foster not too long ago and he had some code partially done from
> about a year or so ago (looks like it has patches from Dave Chinner and Mark
> Tinguely as well).  So I am hoping to be able to use what we have so far to
> create something updated and finished out.  I am still pretty new to the xfs
> code, so at the moment I am still just going through old discussion threads,
> and reviewing the patches.  But for the most part I just wanted to see what
> people thought and get everyone on board with the idea.  Suggestions and
> feedback are much appreciated. Thank you!!
> 

It will be better if you can describe in more details if you have any specific
goal with this, and/or what kind of improvement you expect to have with it,
adding something new without a reason, is usually not well received.

Cheers

-- 
Carlos
