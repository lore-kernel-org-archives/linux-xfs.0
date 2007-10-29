Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 08:05:38 -0700 (PDT)
Received: from mailout3.imos.net (mailout3.imos.net [212.87.132.34])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9TF5V80032493
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 08:05:33 -0700
Message-ID: <4725F6C0.3020303@theendofthetunnel.de>
Date: Mon, 29 Oct 2007 16:05:36 +0100
From: Hannes Dorbath <light@theendofthetunnel.de>
MIME-Version: 1.0
Subject: Re: Default mount options (that suck less).
References: <20071029075657.GA84369978@melbourne.sgi.com> <4725E84D.3030609@sandeen.net>
In-Reply-To: <4725E84D.3030609@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Niv Sardi <xaiki@sgi.com>, xfs@oss.sgi.com

On 29.10.2007 15:03, Eric Sandeen wrote:
> Niv Sardi wrote:
>> XFS's default mount options are in most cases sub-optimal, we should try
>> to have more sensible defaults, so far I'm following some quick dave-powered
>> recomendations:

Is there any reason to not set the default inode size to 512 bytes? ..as 
suggested in:

http://www.suse.de/~agruen/acl/linux-acls/online/


-- 
Regards,
Hannes Dorbath
