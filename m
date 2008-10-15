Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 21:48:42 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F4mcvO032290
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 21:48:38 -0700
Message-ID: <48F5848B.1020409@sgi.com>
Date: Wed, 15 Oct 2008 15:50:03 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: TAKE 988141 - Fix build error - use VFS_I() to access linux	inode
 from xfs inode
References: <20081015021055.6B76358FA1E9@chook.melbourne.sgi.com> <20081015022106.GA22939@infradead.org> <48F563E1.4050909@sgi.com> <48F55F17.1020800@thebarn.com>
In-Reply-To: <48F55F17.1020800@thebarn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com



Russell Cattelan wrote:
> Mark Goodwin wrote:
>>
>>
>> Christoph Hellwig wrote:
>>> FYI I sent this patch out first on 22nd of August, and pinged it on 29th
>>> of Semptember..
>>
>> Thus is why we need something like 'patchworks' hooked into the xfs@oss
>> list - better tracking of patch submissions and their status.
> So what is patchworks?

It's a patch submission tracking system for project mailing lists
such as xfs@oss. See http://ozlabs.org/~jk/projects/patchwork

-- Mark
