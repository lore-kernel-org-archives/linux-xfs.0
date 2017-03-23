Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:52158 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932592AbdCWOcF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Mar 2017 10:32:05 -0400
Subject: Re: Selectively backup based on specific date
References: <0c190757-c4ac-ae5c-6e1c-b9be37470be5@lueckdatasystems.com>
 <1904662.EPkO7u6dZY@xrated>
From: Michael Lueck <mlueck@lueckdatasystems.com>
Message-ID: <889643de-4c95-fa11-029c-50b07355f0ba@lueckdatasystems.com>
Date: Thu, 23 Mar 2017 10:31:59 -0400
MIME-Version: 1.0
In-Reply-To: <1904662.EPkO7u6dZY@xrated>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-xfs@vger.kernel.org

Greetings Hans-Peter,

Hans-Peter Jansen wrote:
> Here are some of my favorite tools:
> 	rsync for ad hoc operations,


Excellent idea!

As this effort involves a slide replacement migration... OK to begin with the xfsrestore from a full backup. Then change the IP on the old server, put both servers on the wire, and rsync to catch up. 
Got it! (y)

I am thankful,

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/
