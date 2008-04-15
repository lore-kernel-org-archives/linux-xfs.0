Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Apr 2008 17:33:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3F0X7sb009736
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2008 17:33:09 -0700
Message-ID: <4803F7DF.50706@sgi.com>
Date: Tue, 15 Apr 2008 10:33:35 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] remove CONFIG_XFS_SECURITY
References: <47819E47.4030906@sandeen.net> <47BB7774.5080401@sandeen.net> <47F985BA.7060100@sgi.com> <47FF781D.2020006@sandeen.net> <20080411160448.GA26929@infradead.org> <47FF8E2A.30900@sandeen.net>
In-Reply-To: <47FF8E2A.30900@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Christoph Hellwig wrote:
>>> +#define XFS_SECURITY_STRING	"security attributes, "
>> This one should just be killed completely, as it's not an optional
>> feature anymore.
>>
> 
> My only concern is that if people are used to seeing it, they'll assume
> that somehow xfs now doesn't support it now, or was built without it, or ...
> 
> *shrug*
> 
> -Eric
Yeah, I kind of see your point there.
I think I'd prefer to keep it too.

--Tim
